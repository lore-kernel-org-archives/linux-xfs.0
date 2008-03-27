Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 27 Mar 2008 01:21:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2R8LGIL002361
	for <xfs@oss.sgi.com>; Thu, 27 Mar 2008 01:21:19 -0700
Date: Thu, 27 Mar 2008 09:21:40 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [dm-crypt] INFO: task mount:11202 blocked for more than 120
 seconds
In-Reply-To: <alpine.DEB.1.00.0803220348520.17137@sheep.housecafe.de>
Message-ID: <alpine.DEB.1.10.0803270918450.5041@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <200803150108.04008.chunkeey@web.de> <200803151432.11125.chunkeey@web.de> <200803152234.53199.chunkeey@web.de> <alpine.DEB.1.00.0803161406040.6213@sheep.housecafe.de>
 <20080317173609.GD29322@agk.fab.redhat.com> <alpine.DEB.1.00.0803220348520.17137@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alasdair G Kergon <agk@redhat.com>
Cc: Chr <chunkeey@web.de>, Milan Broz <mbroz@redhat.com>, David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, dm-devel@redhat.com, dm-crypt@saout.de, Herbert Xu <herbert@gondor.apana.org.au>, Ritesh Raj Sarraf <rrs@researchut.com>

On Sat, 22 Mar 2008, Christian Kujau wrote:
> On Mon, 17 Mar 2008, Alasdair G Kergon wrote:
>> From: Milan Broz <mbroz@redhat.com>
>> 
>> Fix regression in dm-crypt introduced in commit
>> 3a7f6c990ad04e6f576a159876c602d14d6f7fef
>> (dm crypt: use async crypto).

I noticed that this patch[0] hasn't made it into mainline yet,
will this be included or is this fixed by something else?

Thanks,
Christian.

[0] http://lkml.org/lkml/2008/3/17/214
-- 
BOFH excuse #416:

We're out of slots on the server
