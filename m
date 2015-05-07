Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 42F057F37
	for <xfs@oss.sgi.com>; Thu,  7 May 2015 06:48:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 341CA8F804B
	for <xfs@oss.sgi.com>; Thu,  7 May 2015 04:48:45 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id jwEKKfnIZXhwrEew for
	<xfs@oss.sgi.com>; Thu, 07 May 2015 04:48:43 -0700 (PDT)
From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: Valid Benchmark Value & Methods
Date: Thu, 07 May 2015 13:48:34 +0200
Message-ID: <2424481.0uux1ckym9@merkaba>
In-Reply-To: <554B4B59.6000706@xtremenitro.org>
References: <554B4B59.6000706@xtremenitro.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Dewangga <dewanggaba@xtremenitro.org>

Am Donnerstag, 7. Mai 2015, 18:24:09 schrieb Dewangga:
> Hello!
> 
> I'm new on XFS and curious about any tune/tweak regarding XFS
> filesystem on any raid array, non-raid, ssd or non-ssd. But, is there
> any valid value to determine about the performance? At least valid
> benchmark result (eg. using fio with some parameters, or any method).
> 
> Then, about bsize, sectsz, etc, is there any wiki/guidelines how to
> set them on a right way?

Read and understand:

http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E

then, if you want any concrete recommendation ask about your intended setup.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
