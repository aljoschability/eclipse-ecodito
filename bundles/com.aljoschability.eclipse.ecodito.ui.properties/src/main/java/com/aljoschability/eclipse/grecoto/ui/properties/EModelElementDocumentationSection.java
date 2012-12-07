package com.aljoschability.eclipse.grecoto.ui.properties;

import org.eclipse.emf.common.command.Command;
import org.eclipse.emf.common.command.CompoundCommand;
import org.eclipse.emf.ecore.EAnnotation;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EModelElement;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.EcoreFactory;
import org.eclipse.emf.ecore.EcorePackage;
import org.eclipse.emf.ecore.impl.EStringToStringMapEntryImpl;
import org.eclipse.emf.edit.command.AddCommand;

import com.aljoschability.eclipse.core.properties.graphiti.GraphitiElementAdapter;
import com.aljoschability.eclipse.core.ui.properties.State;
import com.aljoschability.eclipse.core.ui.properties.sections.AbstractTextSection;
import com.aljoschability.eclipse.ecodito.GenmodelConstants;

public class EModelElementDocumentationSection extends AbstractTextSection {
	private boolean addAnnotation;
	private EAnnotation annotation;

	private boolean addEntry;
	private EStringToStringMapEntryImpl entry;

	public EModelElementDocumentationSection() {
		super(GraphitiElementAdapter.get());
	}

	@Override
	protected State validate(String value) {
		return State.info("The comment describes the element.");
	}

	@Override
	protected void execute(Command command) {
		CompoundCommand compoundCommand = new CompoundCommand();
		if (addAnnotation) {
			EObject owner = super.getElement();
			EStructuralFeature feature = EcorePackage.Literals.EMODEL_ELEMENT__EANNOTATIONS;
			Command annotationCommand = AddCommand.create(getEditingDomain(), owner, feature, annotation);
			compoundCommand.append(annotationCommand);
			addAnnotation = false;
		}

		if (addEntry) {
			EObject owner = annotation;
			EStructuralFeature feature = EcorePackage.Literals.EANNOTATION__DETAILS;
			Command entryCommand = AddCommand.create(getEditingDomain(), owner, feature, entry);
			compoundCommand.append(entryCommand);
			addEntry = false;
		}

		compoundCommand.append(command);

		super.execute(compoundCommand.unwrap());
	}

	@Override
	protected EObject getElement() {
		EObject element = super.getElement();
		if (element instanceof EModelElement) {
			// annotation
			annotation = ((EModelElement) element).getEAnnotation(GenmodelConstants.SOURCE);
			if (annotation == null) {
				annotation = EcoreFactory.eINSTANCE.createEAnnotation();
				annotation.setSource(GenmodelConstants.SOURCE);
				addAnnotation = true;
			}

			// details entry
			int index = annotation.getDetails().indexOfKey(GenmodelConstants.KEY_DOCUMENTATION);
			if (index == -1) {
				EClass type = EcorePackage.Literals.ESTRING_TO_STRING_MAP_ENTRY;
				entry = (EStringToStringMapEntryImpl) EcoreFactory.eINSTANCE.create(type);
				entry.setKey(GenmodelConstants.KEY_DOCUMENTATION);
				entry.setValue(EMPTY);
				addEntry = true;
			} else {
				entry = (EStringToStringMapEntryImpl) annotation.getDetails().get(index);
			}

			return entry;
		}
		return null;
	}

	@Override
	protected EStructuralFeature getFeature() {
		return EcorePackage.Literals.ESTRING_TO_STRING_MAP_ENTRY__VALUE;
	}

	@Override
	protected String getLabelText() {
		return "Comment";
	}

	@Override
	protected boolean isGroupWrapped() {
		return true;
	}

	@Override
	protected boolean isMultiLine() {
		return true;
	}

	@Override
	protected boolean isUsingMonospace() {
		return true;
	}
}
