Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EDB977F5E
	for <xfs@oss.sgi.com>; Mon, 17 Nov 2014 03:42:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6DF67AC001
	for <xfs@oss.sgi.com>; Mon, 17 Nov 2014 01:42:09 -0800 (PST)
Received: from srv2.trombetti.net (srv2.trombetti.net [65.254.53.252]) by
	cuda.sgi.com with ESMTP id sGGey8cac1XZTPnG for
	<xfs@oss.sgi.com>; Mon, 17 Nov 2014 01:42:07 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested) (Authenticated sender: SASL)
	by srv2.trombetti.net (Postfix) with ESMTPSA id CD0783134A
	for <xfs@oss.sgi.com>; Mon, 17 Nov 2014 04:46:51 -0500 (EST)
Message-ID: <5469C2E8.2080407@shiftmail.org>
Date: Mon, 17 Nov 2014 10:42:00 +0100
From: Spelic <spelic@shiftmail.org>
MIME-Version: 1.0
Subject: Re: Virtual Block device resize corrupts XFS
References: <5468FC60.10901@web.de> <20141116223630.GH23575@dastard>
	<54692E48.80708@shiftmail.org>
In-Reply-To: <54692E48.80708@shiftmail.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 17/11/2014 00:07, Spelic wrote:
>
> Not true! Depends on the allocation strategy chosen for LVM and the 
> position of free space.
> Probably recovering LVM conf from backups (which usually is 
> automatically made) can recover the exact LVM layout of prior to the 
> shrink.

Sorry by bad... he is not using LVM.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
