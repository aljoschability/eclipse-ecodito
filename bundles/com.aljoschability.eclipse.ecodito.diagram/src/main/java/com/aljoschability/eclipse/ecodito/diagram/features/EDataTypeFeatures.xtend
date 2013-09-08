package com.aljoschability.eclipse.ecodito.diagram.features;

import com.aljoschability.eclipse.core.graphiti.features.CoreCreateFeature
import com.aljoschability.eclipse.core.graphiti.services.AddService
import com.aljoschability.eclipse.ecodito.diagram.util.EDataTypeExtensions
import org.eclipse.emf.ecore.EcoreFactory
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
import org.eclipse.graphiti.mm.algorithms.Text

class EDataTypeCreateFeature extends CoreCreateFeature {
	extension EDataTypeExtensions = EDataTypeExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)

		name = "Data Type"
		description = "Create Data Type"
		imageId = identifier
		largeImageId = identifier
	}

	override canCreate(ICreateContext context) {
		return context.EPackage != null
	}

	override createElement(ICreateContext context) {
		val element = EcoreFactory::eINSTANCE.createEDataType
		element.name = context.EPackage.nextEClassifierName("DataType")
		element.instanceClassName = "java.lang.Object"

		context.EPackage.EClassifiers += element

		return element
	}
}

class EDataTypeAddFeature extends AbstractAddFeature {
	extension AddService = AddService::INSTANCE
	extension EDataTypeExtensions = EDataTypeExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override add(IAddContext context) {
		context.container.addContainerShape [
			link = context.newObject
			addRoundedRectangle [
				position = context.position
				size = context.size(200, 100)
				style = mainStyle
				radius = 6
				// image
				addImage(identifier) [
					position = #[7, 7]
					size = #[16, 16]
				]
				// name
				addText [
					position = #[27, 5]
					width = parentGraphicsAlgorithm.width - 54
					height = 20
					style = nameStyle
					value = context.EDataType.text
				]
				// type
				addText [
					position = #[27, 21]
					width = parentGraphicsAlgorithm.width - 54
					height = 20
					style = typeStyle
					value = context.EDataType.typeName
				]
				// name/type separator
				addPolyline[
					addPoint(0, 40)
					addPoint(parentGraphicsAlgorithm.width, 40)
					style = mainStyle
				]
			]
		]
	}

	override canAdd(IAddContext context) {
		context.EPackage != null && context.EDataType != null
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
