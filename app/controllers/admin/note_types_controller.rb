class Admin::NoteTypesController < Admin::BaseController
  menu_item :note_types

  def index
    @page_title = 'Note Types'
    add_breadcrumb 'Admin', 'admin/settings'
    add_breadcrumb 'Note Types'
    redirect_to admin_note_type_path(Core::NoteType.first) if Core::NoteType.count > 0
  end

  def new
    @note_type = Core::NoteType.new
    @note_type.note_types_associations.build
  end

  def create
    @note_type = Core::NoteType.new
    @note_type.assign_attributes note_type_params
    if @note_type.save
      @success = true
    else
      @success = false
    end
  end

  def edit
    @note_type = Core::NoteType.find(params[:id])
  end

  def update
    @note_type = Core::NoteType.find(params[:id])
    if @note_type.update_attributes note_type_params
      @success = true
    else
      @success = false
    end
  end

  def show
    @note_type = Core::NoteType.find(params[:id])
    @page_title = @note_type.name
    add_breadcrumb 'Admin', 'admin/settings'
    add_breadcrumb 'Note Types'
    @custom_fields = @note_type.custom_fields
  end

  def make_default
    @note_type = Core::NoteType.find(params[:id])
    Core::NoteType.update_all(default: false)
    @note_type.update_attribute :default, true
  end

  private
  def note_type_params
    params.require(:core_note_type)
    .permit( :name, :default,
             note_types_associations_attributes: [:id, :association_id, :default, :commentable, :_destroy]
    )
  end
end
