<?php
declare(strict_types=1);
namespace wcf\acp\form;
use wcf\data\devtools\project\DevtoolsProject;
use wcf\form\AbstractForm;
use wcf\form\AbstractFormBuilderForm;
use wcf\system\devtools\pip\DevtoolsPip;
use wcf\system\exception\IllegalLinkException;
use wcf\system\form\builder\container\FormContainer;
use wcf\system\request\LinkHandler;
use wcf\system\WCF;
use wcf\util\StringUtil;

/**
 * Shows the form to add a new entry for a specific pip and project.
 * 
 * @author	Matthias Schmidt
 * @copyright	2001-2018 WoltLab GmbH
 * @license	GNU Lesser General Public License <http://opensource.org/licenses/lgpl-license.php>
 * @package	WoltLabSuite\Core\Acp\Form
 * @since	3.2
 */
class DevtoolsProjectPipEntryAddForm extends AbstractFormBuilderForm {
	/**
	 * @inheritDoc
	 */
	public $activeMenuItem = 'wcf.acp.menu.link.devtools.project.list';
	
	/**
	 * @inheritDoc
	 */
	public $neededModules = ['ENABLE_DEVELOPER_TOOLS'];
	
	/**
	 * @inheritDoc
	 */
	public $neededPermissions = ['admin.configuration.package.canInstallPackage'];
	
	/**
	 * name of the requested pip
	 * @var	string
	 */
	public $pip = '';
	
	/**
	 * devtools project
	 * @var	DevtoolsProject
	 */
	public $project;
	
	/**
	 * project id
	 * @var	integer
	 */
	public $projectID = 0;
	
	/**
	 * devtools pip object for the requested pip
	 * @var	DevtoolsPip
	 */
	protected $pipObject;
	
	/**
	 * @inheritDoc
	 */
	public function readParameters() {
		parent::readParameters();
		
		if (isset($_REQUEST['id'])) $this->projectID = intval($_REQUEST['id']);
		$this->project = new DevtoolsProject($this->projectID);
		if (!$this->project->projectID) {
			throw new IllegalLinkException();
		}
		
		$this->project->validatePackageXml();
		
		if (isset($_REQUEST['pip'])) $this->pip = StringUtil::trim($_REQUEST['pip']);
		
		$filteredPips = array_filter($this->project->getPips(), function(DevtoolsPip $pip) {
			return $pip->pluginName === $this->pip;
		});
		if (count($filteredPips) === 1) {
			$this->pipObject = reset($filteredPips);
		}
		else {
			throw new IllegalLinkException();
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function readData() {
		// we have to do it here so that the pip object is available to
		// add the pip-specific form fields
		$this->addPipFormFields();
		
		parent::readData();
	}
	
	/**
	 * Adds the pip-specific form fields.
	 */
	protected function addPipFormFields() {
		$this->form->appendChild(
			FormContainer::create('data')
				->label('wcf.global.form.data')
		);
		
		$this->pipObject->getPip()->addFormFields($this->form);
	}
	
	/**
	 * @inheritDoc
	 */
	public function save() {
		AbstractForm::save();
		
		$this->pipObject->getPip()->addEntry($this->form);
		
		$this->saved();
		
		// re-build form after having created a new object
		if ($this->formAction === 'create') {
			$this->buildForm();
			$this->addPipFormFields();
		}
		
		WCF::getTPL()->assign('success', true);
	}
	
	/**
	 * @inheritDoc
	 */
	public function setFormAction() {
		$this->form->action(LinkHandler::getInstance()->getLink('DevtoolsProjectPipEntryAdd', [
			'id' => $this->project->projectID,
			'pip' => $this->pip
		]));
	}
	
	/**
	 * @inheritDoc
	 */
	public function assignVariables() {
		parent::assignVariables();
		
		WCF::getTPL()->assign([
			'action' => 'add',
			'pip' => $this->pip,
			'project' => $this->project
		]);
	}
}
