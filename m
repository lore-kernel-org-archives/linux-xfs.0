Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 02:32:40 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6L9WWpE006963
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 02:32:33 -0700
Message-ID: <488457F3.2050405@cape-horn-eng.com>
Date: Mon, 21 Jul 2008 11:33:39 +0200
From: Richard Ems <Richard.Ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: XFS internal error xfs_btree_check_lblock
References: <4880AEF8.2080906@cape-horn-eng.com> <48815AA6.3080102@sgi.com>
In-Reply-To: <48815AA6.3080102@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: xfs@oss.sgi.com, Bill O'Donnell <billodo@sgi.com>

Mark Goodwin wrote:
> Hi Richard,
> 
> this looks like XFS b-tree corruption of some sort. We have some patches
> that should help here. The patches are being back-ported to SLES10 and
> should also apply to OpenSUSE. We should have something ready early next
> week.

Thanks Mark. The most annoying thing is that, after many repairs, it's 
working again! But my big question is ... for how long? How stable is 
the filesystem now? Should I better recreate it? WHY did this happen? 
Why did the FS fail again after some repairs?  8(

Where can I get more info about these patches? Is there a developer 
mailing list? Or some webpage to follow the development progress?

Thanks, Richard




-- 
Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. Dómine 1, 5º piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
