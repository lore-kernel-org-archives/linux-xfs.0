Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 09 Jul 2007 20:53:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6A3rWbm005173
	for <xfs@oss.sgi.com>; Mon, 9 Jul 2007 20:53:35 -0700
Message-ID: <469302B7.7090306@sgi.com>
Date: Tue, 10 Jul 2007 13:53:27 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Fwd: xfs_fsr and null byte areas in files (REPOST) / file data
 checksumming
References: <200707092313.48876.Martin@lichtvoll.de> <20070710005030.GQ31489@sgi.com>
In-Reply-To: <20070710005030.GQ31489@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

David Chinner wrote:
> On Mon, Jul 09, 2007 at 11:13:48PM +0200, Martin Steigerwald wrote:
>> 1) Is there an XFS qa test available for xfs_fsr? If so I could use that 
>> one. Are there some hints on how to get started on XFS qa?
> 
> Yes, test 042. Download it from CVS, build it (installing all the
> bits it asks for ;), edit common.config to add your test and scratch
> partitions (both volatile) and the 'check -l 042' to run test 042.
> 
Yeah, get the xfstests package and read the README in there.
If the README is not clear or you have other trouble then let me/us know.

--Tim
