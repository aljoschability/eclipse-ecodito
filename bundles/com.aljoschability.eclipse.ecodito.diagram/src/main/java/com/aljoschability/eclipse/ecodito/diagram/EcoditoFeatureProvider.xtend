package com.aljoschability.eclipse.ecodito.diagram

import com.aljoschability.eclipse.core.graphiti.util.GraphitiExtensions
import com.aljoschability.eclipse.ecodito.diagram.features.EAttributeAddFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EAttributeLayoutFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EAttributeUpdateFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EClassAddFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EClassLayoutFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EClassUpdateFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EDataTypeAddFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EDataTypeDirectEditingFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EDataTypeLayoutFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EDataTypeUpdateFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EEnumAddFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EEnumLayoutFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EEnumLiteralAddFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EEnumLiteralLayoutFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EEnumLiteralUpdateFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EEnumUpdateFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EOperationAddFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EOperationLayoutFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EOperationUpdateFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EReferenceAddFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EReferenceUpdateFeature
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EDataType
import org.eclipse.emf.ecore.EEnum
import org.eclipse.emf.ecore.EEnumLiteral
import org.eclipse.emf.ecore.EOperation
import org.eclipse.emf.ecore.EReference
import org.eclipse.graphiti.dt.IDiagramTypeProvider
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.IDirectEditingContext
import org.eclipse.graphiti.features.context.ILayoutContext
import org.eclipse.graphiti.features.context.IUpdateContext
import org.eclipse.graphiti.ui.features.DefaultFeatureProvider
import org.eclipse.graphiti.features.context.IResizeShapeContext
import com.aljoschability.eclipse.core.graphiti.features.NoResizeShapeFeature

class EcoditoFeatureProvider extends DefaultFeatureProvider {
	extension GraphitiExtensions = GraphitiExtensions::INSTANCE

	new(IDiagramTypeProvider dtp) {
		super(dtp)
	}

	override getAddFeature(IAddContext context) {
		switch context.newObject {
			EEnum: new EEnumAddFeature(this)
			EEnumLiteral: new EEnumLiteralAddFeature(this)
			EClass: new EClassAddFeature(this)
			EAttribute: new EAttributeAddFeature(this)
			EReference: new EReferenceAddFeature(this)
			EOperation: new EOperationAddFeature(this)
			EDataType: new EDataTypeAddFeature(this)
			default: super.getAddFeature(context)
		}
	}

	override getResizeShapeFeature(IResizeShapeContext context) {
		switch context.bo {
			EAttribute: new NoResizeShapeFeature(this)
			EOperation: new NoResizeShapeFeature(this)
			EEnumLiteral: new NoResizeShapeFeature(this)
			default: super.getResizeShapeFeature(context)
		}
	}

	override getDirectEditingFeature(IDirectEditingContext context) {
		switch context.bo {
			EDataType: new EDataTypeDirectEditingFeature(this)
			default: super.getDirectEditingFeature(context)
		}
	}

	override getLayoutFeature(ILayoutContext context) {

		//EReference: new EReferenceLayoutFeature(this)
		switch context.bo {
			EEnum: new EEnumLayoutFeature(this)
			EEnumLiteral: new EEnumLiteralLayoutFeature(this)
			EClass: new EClassLayoutFeature(this)
			EAttribute: new EAttributeLayoutFeature(this)
			EOperation: new EOperationLayoutFeature(this)
			EDataType: new EDataTypeLayoutFeature(this)
			default: super.getLayoutFeature(context)
		}
	}

	override getUpdateFeature(IUpdateContext context) {
		switch context.bo {
			EEnum: new EEnumUpdateFeature(this)
			EEnumLiteral: new EEnumLiteralUpdateFeature(this)
			EClass: new EClassUpdateFeature(this)
			EAttribute: new EAttributeUpdateFeature(this)
			EReference: new EReferenceUpdateFeature(this)
			EOperation: new EOperationUpdateFeature(this)
			EDataType: new EDataTypeUpdateFeature(this)
			default: super.getUpdateFeature(context)
		}
	}
}
