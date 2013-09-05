package com.aljoschability.eclipse.ecodito.diagram.util

import com.aljoschability.eclipse.ecodito.diagram.styles.EDataTypeStyles
import org.eclipse.emf.ecore.EDataType
import org.eclipse.emf.ecore.EEnum
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.IDirectEditingContext
import org.eclipse.graphiti.features.context.IPictogramElementContext
import org.eclipse.graphiti.mm.algorithms.Text
import org.eclipse.graphiti.mm.algorithms.styles.Style
import org.eclipse.graphiti.mm.pictograms.Diagram
import org.eclipse.graphiti.services.Graphiti
import org.eclipse.graphiti.services.IGaService
import org.eclipse.graphiti.util.IColorConstant

class EDataTypeExtensions extends EClassifierExtensions {
	val static public INSTANCE = new EDataTypeExtensions

	extension IGaService = Graphiti::gaService
	extension EDataTypeStyles = EDataTypeStyles::INSTANCE

	private new() {
	}

	def Style getDefaultStyle(Diagram diagram) {
		var style = diagram.findStyle(EcorePackage.Literals::EDATA_TYPE.name)

		if (style == null) {
			style = diagram.createStyle(EcorePackage.Literals::EDATA_TYPE.name)

			style.renderingStyle = createGradientColoredAreas(diagram)
			style.foreground = diagram.manageColor(IColorConstant::BLACK)
		}

		return style
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

	def Text getNameText(IDirectEditingContext context) {
		val text = context.graphicsAlgorithm.graphicsAlgorithmChildren.get(1)
		if (text instanceof Text) {
			return text
		}
	}

	def String nextName(EPackage ePackage, String prefix) {
		var index = 1
		var name = prefix + index
		while (ePackage.getEClassifier(name) != null) {
			name = prefix + index++
		}
		return name
	}

	def private static EDataType getEDataType(Object element) {
		if (element instanceof EDataType) {
			if (!(element instanceof EEnum)) {
				return element
			}
		}
	}
}
