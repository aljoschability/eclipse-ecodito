package com.aljoschability.eclipse.ecodito.diagram.features;

import com.aljoschability.eclipse.core.graphiti.features.CoreCreateFeature
import com.aljoschability.eclipse.ecodito.diagram.util.EDataTypeExtensions
import org.eclipse.emf.ecore.EDataType
import org.eclipse.emf.ecore.EcoreFactory
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.IFeatureProvider
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.ICreateContext
import org.eclipse.graphiti.features.context.IDirectEditingContext
import org.eclipse.graphiti.features.context.ILayoutContext
import org.eclipse.graphiti.features.context.IUpdateContext
import org.eclipse.graphiti.features.impl.AbstractAddFeature
import org.eclipse.graphiti.features.impl.AbstractDirectEditingFeature
import org.eclipse.graphiti.features.impl.AbstractLayoutFeature
import org.eclipse.graphiti.features.impl.AbstractUpdateFeature
import org.eclipse.graphiti.features.impl.Reason
import org.eclipse.graphiti.util.IColorConstant
import org.eclipse.graphiti.mm.algorithms.Text

class EDataTypeAddFeature extends AbstractAddFeature {
	extension EDataTypeExtensions = EDataTypeExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override add(IAddContext context) {
		addContainerShape[
			container = context.container
			active = true
			link = context.newObject
			val frame = addRoundedRectangle[
				style = diagram.defaultStyle
				//background = IColorConstant::WHITE
				//foreground = IColorConstant::BLACK
				radius = 16
				position = context.position
				size = context.size(200, 100)
				val titleSymbol = addImage[
					//name = "title.symbol"
					id = EDataType.simpleName
					position = #[7, 7]
					size = #[16, 16]
				]
				val titleText = addText[
					//name = "title.text"
					position = #[27, 5]
					width = parentGraphicsAlgorithm.width - 54
					foreground = IColorConstant::BLACK
					height = 20
					//font = nameFont
					value = context.EDataType.name
				]
				val titleSeparator = addPolyline[
					//name = "title.separator"
					addPoint(0, 29)
					addPoint(parentGraphicsAlgorithm.width, 29)
				]
			]
		]
	}

	override canAdd(IAddContext context) {
		context.EPackage != null && context.EDataType != null
	}
}

class EDataTypeCreateFeature extends CoreCreateFeature {
	extension EDataTypeExtensions = EDataTypeExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)

		name = "Data Type"
		description = "Create Data Type"
		imageId = EcorePackage.Literals::EDATA_TYPE.name
		largeImageId = EcorePackage.Literals::EDATA_TYPE.name

		editable = false
	}

	override canCreate(ICreateContext context) {
		return context.EPackage != null
	}

	override createElement(ICreateContext context) {
		val element = EcoreFactory::eINSTANCE.createEDataType
		element.name = context.EPackage.nextName("DataType")

		context.EPackage.EClassifiers += element

		return element
	}
}

class EDataTypeDirectEditingFeature extends AbstractDirectEditingFeature {
	extension EDataTypeExtensions = EDataTypeExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override canDirectEdit(IDirectEditingContext context) {
		context.EDataType != null && context.graphicsAlgorithm instanceof Text
	}

	override getEditingType() {
		TYPE_TEXT
	}

	override getInitialValue(IDirectEditingContext context) {
		context.EDataType.name
	}

	override setValue(String value, IDirectEditingContext context) {
		context.EDataType.name = value
	}

	override stretchFieldToFitText() {
		true
	}
}

class EDataTypeLayoutFeature extends AbstractLayoutFeature {
	extension EDataTypeExtensions = EDataTypeExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override canLayout(ILayoutContext context) {
		context.EDataType != null
	}

	override layout(ILayoutContext context) {
		false
	}
}

class EDataTypeUpdateFeature extends AbstractUpdateFeature {
	extension EDataTypeExtensions = EDataTypeExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override canUpdate(IUpdateContext context) {
		context.EDataType != null
	}

	override updateNeeded(IUpdateContext context) {
		Reason::createFalseReason
	}

	override update(IUpdateContext context) {
		false
	}
}
