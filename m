Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBJAnWlZ078155 for <xfs@oss.sgi.com>; Sat, 19 Dec 2009 04:49:33 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E03BBE7477C
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2009 02:50:12 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id pXvl9AvKMz67PH2r for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2009 02:50:12 -0800 (PST)
Received: from shambhala.localnet (ppp-88-217-126-217.dynamic.mnet-online.de
	[88.217.126.217])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 34EC15AEE4
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2009 11:50:11 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: xfs in memory corruption
Date: Sat, 19 Dec 2009 11:50:09 +0100
References: <C751BC0C.A22%bchang@greenplum.com>
	(sfid-20091219_102515_637248_8BDD3A38)
	(sfid-20091219_102515_637248_8BDD3A38)
	(sfid-20091219_102515_637248_8BDD3A38)
In-Reply-To: <C751BC0C.A22%bchang@greenplum.com>
MIME-Version: 1.0
Message-Id: <200912191150.10149.Martin@lichtvoll.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Am Samstag 19 Dezember 2009 schrieb Brady Chang:
> Hi 

Hi Brady,

> all, got the following error on one of our test machines. SLES10 SP2
>  with stock kernel
> 
> I've not had the chance to scrutinize complete /var/log/messages for
>  additional helpful info. Any advanced help is appreciated.

Thats likely 2.6.16.something. I strongly advise to upgrade the kernel.

Quite some XFS issues have been already fixed since then.

If you can't upgrade your kernel, I advise to contact Novell / SUSE 
support and they whether they can backport a fix for this to their ancient 
kernel.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
