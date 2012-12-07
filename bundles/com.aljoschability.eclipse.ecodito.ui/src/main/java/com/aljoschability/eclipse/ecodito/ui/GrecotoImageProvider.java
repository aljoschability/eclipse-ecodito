package com.aljoschability.eclipse.ecodito.ui;

import org.eclipse.emf.ecore.EcorePackage;
import org.eclipse.graphiti.ui.platform.AbstractImageProvider;

public class GrecotoImageProvider extends AbstractImageProvider {
	@Override
	protected void addAvailableImages() {
		// elements
		addImageFilePath(EcorePackage.Literals.ECLASS.getInstanceTypeName(), "icons/elements/EClass.png");
		addImageFilePath(EcorePackage.Literals.EDATA_TYPE.getInstanceTypeName(), "icons/elements/EDataType.png");
		addImageFilePath(EcorePackage.Literals.EENUM.getInstanceTypeName(), "icons/elements/EEnum.png");
	}
}
