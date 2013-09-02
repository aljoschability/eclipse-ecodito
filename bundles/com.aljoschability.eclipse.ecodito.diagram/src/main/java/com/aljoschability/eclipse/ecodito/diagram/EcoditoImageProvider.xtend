package com.aljoschability.eclipse.ecodito.diagram

import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.ui.platform.AbstractImageProvider

class EcoditoImageProvider extends AbstractImageProvider {
	override protected addAvailableImages() {
		for (type : EcorePackage::eINSTANCE.EClassifiers) {
			if (type instanceof EClass) {
				if (!type.abstract && !type.interface) {
					addImageFilePath(type.name, '''icons/ecore/«type.name».png''')
				}
			}
		}
	}
}
