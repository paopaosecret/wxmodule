#!/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/bin/ruby

require 'xcodeproj'
require 'pathname'

# TODO 全部函数的错误提示及退出

class SubProjectDispose
    attr_reader :mainproj_path, :subproj_path, :main_project ,:sub_project,:subproj_ref_in_mainproj,:subproj_product_group_ref
    def initialize(mainproj_path,subproj_path, main_target_name, replaykit_target_name)
        @mainproj_path = mainproj_path
        @subproj_path = subproj_path
        @main_project = Xcodeproj::Project.open(mainproj_path)

        # @main_project.targets.each do |target| 
        #     if (target.name == main_target_name)
        #         @main_target = target
        #     end
        #     if (target.name == replaykit_target_name)
        #         puts "found replaykit target"
        #         @replaykit_target = target
        #     end
        # end

        # puts "main target is #{@main_target.name}"
    end

    #根据productReference 找到其对应的target
    def get_target_with_productReference(productReference,project)
        project.native_targets.each { |target|
            if target.product_reference == productReference
                # puts "target = #{target}"
                return target
            end
        }
    end

    def add_new_subProj(group, path, source_tree)
        @subproj_ref_in_mainproj = Xcodeproj::Project::FileReferencesFactory.send(:new_file_reference, group, path, :group)
        @subproj_ref_in_mainproj.include_in_index = nil
        @subproj_ref_in_mainproj.name = Pathname(subproj_path).basename.to_s
        #product_group_ref = group.new_group("Products") 这种方式创建的group会挂载在main_group下,这会导致删除的时候,出现一个空的group,而手动拖动的就不会,所以改为group.project.new(Xcodeproj::Project::PBXGroup)
        #从xcode手动添加子工程来看,它要创建一个包含子工程的group
        product_group_ref = group.project.new(Xcodeproj::Project::PBXGroup)
        product_group_ref.name = "Products" #手动拖动创建的group名字就是Products
        @sub_project = Xcodeproj::Project.open(path) #打开子工程

        # @sub_project.groups.each do |group|
        #     if (group.name == "Product")
        #         @product_group = group
        #         # group.files.each do |child|
        #         #     puts "#{child.path}"
        #         # end
        #     end
        # end


        @sub_project.products_group.files.each do |product_reference|
        # @product_group.files.each do |product_reference|
            # puts "product_reference = #{product_reference},name = #{product_reference.name},path = #{product_reference.path}"#product_reference = FileReference,name = ,path = ChencheMaBundle.bundle reference_proxy.file_type = wrapper.plug-in
            container_proxy = group.project.new(Xcodeproj::Project::PBXContainerItemProxy)
            container_proxy.container_portal = @subproj_ref_in_mainproj.uuid
            container_proxy.proxy_type = Xcodeproj::Constants::PROXY_TYPES[:reference]
            container_proxy.remote_global_id_string = product_reference.uuid
            #container_proxy.remote_info = 'Subproject' #这里和手动添加的是不一致的,手动的,这里是targets的名字
            subproj_native_target = get_target_with_productReference(product_reference,@sub_project)
            container_proxy.remote_info = subproj_native_target.name
            reference_proxy = group.project.new(Xcodeproj::Project::PBXReferenceProxy)
            extension = File.extname(product_reference.path)[1..-1]
            # puts("product_reference.path = #{product_reference.path}")
            if extension == "bundle"
                #xcodeproj的定义中,后缀为bundle的对应的是'bundle'       => 'wrapper.plug-in',但是我们手动拖动添加的是 'wrapper.cfbundle'
                reference_proxy.file_type = 'wrapper.cfbundle'
            elsif
            reference_proxy.file_type = Xcodeproj::Constants::FILE_TYPES_BY_EXTENSION[extension]
            end

            reference_proxy.path = product_reference.path
            reference_proxy.remote_ref = container_proxy
            reference_proxy.source_tree = 'BUILT_PRODUCTS_DIR'
            product_group_ref << reference_proxy
        end
        @subproj_product_group_ref = product_group_ref
        attribute = Xcodeproj::Project::PBXProject.references_by_keys_attributes.find { |attrb| attrb.name == :project_references }
        project_reference = Xcodeproj::Project::ObjectDictionary.new(attribute, group.project.root_object)
        project_reference[:project_ref] = @subproj_ref_in_mainproj
        project_reference[:product_group] = product_group_ref
        group.project.root_object.project_references << project_reference
        product_group_ref
    end

    def is_have_subproj()
        self.main_project.main_group.children.grep(Xcodeproj::Project::Object::PBXGroup) do |group|
            if (group.name == "Sources")
                group.children.each do |child|
                    if (child.name == "all.xcodeproj")
                        return true
                    end
                end
            end
        end
        return false
    end

    def add_subproject()
        self.main_project.main_group.children.grep(Xcodeproj::Project::Object::PBXGroup) do |group|
            if (group.name == "Sources") 
                add_new_subProj(group,self.subproj_path,:group)
            end
        end
    end

    def add_args_gn()
        self.main_project.main_group.children.grep(Xcodeproj::Project::Object::PBXGroup) do |group|
            if (group.name == "Sources")
                argsPath = ENV['ARGS_DIR']
                group.new_reference(argsPath)
            end
        end
    end

    def add_framework_in_target(proxy, framework_name, target)
        # 这里使用动态库，静态库需要改动
        if (proxy.path == framework_name && proxy.name == nil)
            puts "add framework #{proxy.path}, target is #{target.name}"
            target.frameworks_build_phase.add_file_reference(proxy)
            # TODO 可能会在copy_phases中找不到Embed Frameworks，那就需要自己创建
            target.copy_files_build_phases.each do |copy_phases|
                if (copy_phases.name == "Embed Frameworks")
                    build_file = @main_project.new(Xcodeproj::Project::PBXBuildFile)
                    build_file.file_ref = proxy
                    build_file.settings = {"ATTRIBUTES" => ["CodeSignOnCopy", "RemoveHeadersOnCopy"]}
                    copy_phases.files << build_file
                    build_file
                end
            end

            # puts "#{proxy.remote_ref.class}"
            @sub_project.native_targets.each do |sub_target|
                if(sub_target.name == "#{proxy.remote_ref.remote_info}")
                    @sub_depend_uuid = sub_target.uuid
                end
            end

            container_proxy = @main_project.new(Xcodeproj::Project::PBXContainerItemProxy)
            container_proxy.container_portal = @subproj_ref_in_mainproj.uuid
            container_proxy.proxy_type = Xcodeproj::Constants::PROXY_TYPES[:native_target] #1
            container_proxy.remote_global_id_string = @sub_depend_uuid
            container_proxy.remote_info = proxy.remote_ref.remote_info

            target_dependency = @main_project.new(Xcodeproj::Project::PBXTargetDependency)
            target_dependency.name = proxy.remote_ref.remote_info
            target_dependency.target_proxy = container_proxy
            target.dependencies << target_dependency
        end
    end

    def add_framework(name)
        project_references = @main_project.root_object.project_references
        project_references.find do |ref|
            ref[:product_group].children.each do |proxy|
                add_framework_in_target(proxy, name, @main_target)
                add_framework_in_target(proxy, 'TXLiteAVSDK_ReplayKitExt.framework', @replaykit_target)
            end
        end
    end

    def add_framework_search_path(path)
        @main_target.build_configuration_list.build_configurations.each do |config|
            # config.build_settings['FRAMEWORK_SEARCH_PATHS'] << path
            paths = Array(config.build_settings['FRAMEWORK_SEARCH_PATHS'])
            paths << path
            config.build_settings['FRAMEWORK_SEARCH_PATHS'] = paths
        end
        @replaykit_target.build_configuration_list.build_configurations.each do |config|
            paths = Array(config.build_settings['FRAMEWORK_SEARCH_PATHS'])
            paths << path
            config.build_settings['FRAMEWORK_SEARCH_PATHS'] = paths
        end
    end

    def remove_framework(name) 
        @main_target.frameworks_build_phases.files_references.each do |ref|
            if (ref.path == name)
                @main_target.frameworks_build_phase.remove_file_reference(ref)
            end
        end
        @replaykit_target.frameworks_build_phases.files_references.each do |ref|
            if (ref.path == 'TXLiteAVSDK_ReplayKitExt.framework')
                @replaykit_target.frameworks_build_phase.remove_file_reference(ref)
            end
        end
    end

    def add_frameworks_build_phase()
        puts("self.subproj_product_group_ref = #{self.subproj_product_group_ref}")
        reference_proxys = self.subproj_product_group_ref.children.grep(Xcodeproj::Project::PBXReferenceProxy)
        reference_proxys.each do |reference_proxy|
            if (reference_proxy.file_type == Xcodeproj::Constants::FILE_TYPES_BY_EXTENSION["a"]) || (reference_proxy.file_type == Xcodeproj::Constants::FILE_TYPES_BY_EXTENSION["bundle"]) then
                puts("reference_proxy = #{reference_proxy}")
                native_target = self.main_project.native_targets.first
                native_target.frameworks_build_phase.add_file_reference(reference_proxy)
            end
        end
    end

    def close()
        self.main_project.save()
    end

end


appPrjPath = ENV['APP_PROJECT_DIR']
sdkPrjPath = ENV['SDK_PROJECT_DIR']
# removeFrameworkName = ENV['REMOVE_FRAMEWORK_NAME']
# addFrameworkName = ENV['ADD_FRAMEWORK_NAME']
# freamworkSearchPath = ENV['FRAMEWORK_SEARCH_PATH']
# TODO mainTargetName可能需要判空操作
# mainTargetName = ENV['MAIN_TARGET_NAME']
# replayKitTargetName = ENV['REPLAYKIT_TARGET_NAME']

# puts "#{appPrjPath}"
# puts "#{sdkPrjPath}"

dispose = SubProjectDispose.new(appPrjPath, sdkPrjPath, nil, nil)
# dispose.remove_framework(removeFrameworkName);
# dispose.add_framework(addFrameworkName)
# dispose.add_framework_search_path(freamworkSearchPath);

if (!dispose.is_have_subproj()) 
    dispose.add_args_gn()
    dispose.add_subproject()
else
    # TODO 判断是否非法
end

dispose.close()

