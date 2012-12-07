package com.aljoschability.eclipse.ecodito.preferences;

import java.util.Collection
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

public class GrecotoPreferencePage extends PreferencePage implements IWorkbenchPreferencePage {
	public new() {
		super("Ecore Tooling");

	// TODO
	}

	override protected Control createContents(Composite parent) {

		// style
		var Group appearanceGroup = new Group(parent, SWT.NONE)
		appearanceGroup.layoutData = GridLayoutFactory.fillDefaults().margins(6, 6).numColumns(2).create
		appearanceGroup.text = "Appearance";

		createAppearanceGroup(appearanceGroup)

		return appearanceGroup;
	}

	def private void createAppearanceGroup(Composite parent) {
		var Label themeLabel = new Label(parent, SWT.TRAIL)
		themeLabel.layoutData = GridDataFactory.fillDefaults().create
		themeLabel.text = "Style";

		var Combo themeCombo = new Combo(parent, SWT.READ_ONLY)
		themeCombo.layoutData = GridDataFactory.fillDefaults().grab(true, false).create
		themeCombo.setItems(items);
	}

	def private String[] getItems() {
		var Collection<String> items = newArrayList

		items.add("Ecore Tools")
		items.add("Plain")

		return items.toArray(newArrayOfSize(items.size))
	}

	override void init(IWorkbench workbench) {
		// not necessary
	}
}
