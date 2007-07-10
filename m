Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jul 2007 08:53:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6AFqwbm025076
	for <xfs@oss.sgi.com>; Tue, 10 Jul 2007 08:53:00 -0700
Message-ID: <4693AA69.5080009@sandeen.net>
Date: Tue, 10 Jul 2007 10:48:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Fwd: xfs_fsr and null byte areas in files (REPOST) / file data
 checksumming
References: <200707092313.48876.Martin@lichtvoll.de> <20070710005030.GQ31489@sgi.com> <469302B7.7090306@sgi.com>
In-Reply-To: <469302B7.7090306@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

Timothy Shimmin wrote:
> David Chinner wrote:
>> On Mon, Jul 09, 2007 at 11:13:48PM +0200, Martin Steigerwald wrote:
>>> 1) Is there an XFS qa test available for xfs_fsr? If so I could use that 
>>> one. Are there some hints on how to get started on XFS qa?
>> Yes, test 042. Download it from CVS, build it (installing all the
>> bits it asks for ;), edit common.config to add your test and scratch
>> partitions (both volatile) and the 'check -l 042' to run test 042.
>>
> Yeah, get the xfstests package and read the README in there.
> If the README is not clear or you have other trouble then let me/us know.

ENOPKG... just cvs.  I'd always thought that packaging it up for
distribution might be a good idea, what do you think?  :)

-Eric

> --Tim
> 
> 
