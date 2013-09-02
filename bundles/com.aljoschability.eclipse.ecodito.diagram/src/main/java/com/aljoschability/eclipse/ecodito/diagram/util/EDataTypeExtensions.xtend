package com.aljoschability.eclipse.ecodito.diagram.util

import org.eclipse.emf.ecore.EDataType
import org.eclipse.emf.ecore.EEnum
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.IPictogramElementContext

class EDataTypeExtensions extends EClassifierExtensions {
	val static public INSTANCE = new EDataTypeExtensions

	private new() {
	}

	def String getIcon() {
		EcorePackage.Literals::EDATA_TYPE.name
	}

	def EDataType getEDataType(IPictogramElementContext context) {
		context.bo.EDataType
	}

	def EDataType getEDataType(IAddContext context) {
		context.newObject.EDataType
	}

	def private static EDataType getEDataType(Object element) {
		if (element instanceof EDataType) {
			if (!(element instanceof EEnum)) {
				return element
			}
		}
	}
}
