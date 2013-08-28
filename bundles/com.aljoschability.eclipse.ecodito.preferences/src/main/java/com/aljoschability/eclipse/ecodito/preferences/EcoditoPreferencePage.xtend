package com.aljoschability.eclipse.ecodito.preferences;

import org.eclipse.jface.layout.GridDataFactory
import org.eclipse.jface.layout.GridLayoutFactory
import org.eclipse.jface.preference.PreferencePage
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Combo
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Control
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Label
import org.eclipse.ui.IWorkbench
import org.eclipse.ui.IWorkbenchPreferencePage

class EcoditoPreferencePage extends PreferencePage implements IWorkbenchPreferencePage {
	new() {
		super("Ecore Diagram Tooling")
	}

	override protected Control createContents(Composite parent) {

		// style
		val Group group = new Group(parent, SWT::NONE)
		group.layoutData = GridLayoutFactory.swtDefaults.numColumns(2).create
		group.text = "Appearance"

		createAppearanceGroup(group)

		return group
	}

	def private void createAppearanceGroup(Composite parent) {
		val label = new Label(parent, SWT::TRAIL)
		label.layoutData = GridDataFactory::fillDefaults.create
		label.text = "Style"

		val control = new Combo(parent, SWT::READ_ONLY)
		control.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		control.items = items
	}

	def private String[] getItems() {
		var items = newArrayList

		items += "Ecore Tools"
		items += "Plain"

		return items
	}

	override void init(IWorkbench workbench) {
		// not necessary
	}
}
