Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Nov 2006 07:45:00 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAMFioaG006557
	for <xfs@oss.sgi.com>; Wed, 22 Nov 2006 07:44:51 -0800
Message-ID: <45647042.2040604@sandeen.net>
Date: Wed, 22 Nov 2006 09:44:02 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
References: <455CB54F.8080901@sandeen.net> <455CE1E3.7020703@sandeen.net>	 <45612621.5010404@sandeen.net>  <45627A4D.3020502@sandeen.net> <1164157336.19915.43.camel@xenon.msp.redhat.com> <5A1AC29043EE33BEB778198A@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <5A1AC29043EE33BEB778198A@timothy-shimmins-power-mac-g5.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Russell Cattelan <cattelan@thebarn.com>, xfs@oss.sgi.com

Timothy Shimmin wrote:
> Thanks, Russell.
> 
> I've been going thru the irc and just started looking at the patch.
> I'll get back to you about it tomorrow.
> 
> I agree it would be good to have the fixed forkoff for data btree roots
> as the first fix. And look into redoing the btree root for a later change.

My only question is, how much does this defeat the purpose of attr2?

-Eric
