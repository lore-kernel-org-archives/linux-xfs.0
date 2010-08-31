Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7V7Zt0P049568 for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 02:35:56 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AFAB23B99C
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 00:36:32 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id SPgUXJ1tOPvupCMx
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 00:36:32 -0700 (PDT)
Message-ID: <4C7CB0FE.1020302@profihost.ag>
Date: Tue, 31 Aug 2010 09:36:30 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: XFS Quota Check OOM
References: <4C7BA0A0.5090202@profihost.ag>
In-Reply-To: <4C7BA0A0.5090202@profihost.ag>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Can really nobody help :-(

Stefan

Am 30.08.2010 14:14, schrieb Stefan Priebe - Profihost AG:
> Hi,
>
> on one of our systems i want to activate prjquota support. The relevant
> disk is the root disk so i added prjquota to rootflags kernel line.
>
> But when i do so i always get OOM out of Memory while checking quota's.
> I also upgraded the system from 8GB to 16GB RAM but still the same.
> Kernel is vanilla 2.6.32.19.
>
> Stefan
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
