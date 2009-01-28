Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0SKPj7A151016 for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 14:25:45 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 19E9418817D8
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 12:25:03 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id wscJRtCnctKSkvBm for
	<xfs@oss.sgi.com>; Wed, 28 Jan 2009 12:25:03 -0800 (PST)
Received: from shambhala.lichtvoll.home
	(DSL01.212.114.235.144.ip-pool.NEFkom.net [212.114.235.144])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id E74AD5AE91
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 21:25:02 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: [PATCH] xfs: cleanup error handling in xfs_swap_extents
Date: Wed, 28 Jan 2009 21:25:23 +0100
References: <20090126073136.384490000@bombadil.infradead.org>
	<20090126075552.GA1062@infradead.org>
	<20090127002739.GO5587@josefsipek.net>
	(sfid-20090127_115035_586596_A8E5110A)
In-Reply-To: <20090127002739.GO5587@josefsipek.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901282125.24272.Martin@lichtvoll.de>
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

Am Dienstag 27 Januar 2009 schrieb Josef 'Jeff' Sipek:
> From: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
>
> Use multiple lables for proper error unwinding and get rid of some now
> superflous variables.

Typo in description: s/lables/labels

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
