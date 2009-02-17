Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1HFJote231549 for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 09:19:50 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3345B129F4E
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 07:19:16 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id qrdqfVV6w2KooeIV for
	<xfs@oss.sgi.com>; Tue, 17 Feb 2009 07:19:16 -0800 (PST)
Date: Tue, 17 Feb 2009 16:19:15 +0100
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs problems (possibly after upgrading from linux kernel
	2.6.27.10	to .14)
Message-ID: <017cbf6388451888f2156b2fb77115e8@webmail.zmi.at>
In-Reply-To: <499ACE6C.4060304@aei.mpg.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

"Carsten Aulbert" <carsten.aulbert@aei.mpg.de> schrieb:
> Feb 16 20:34:49 n0035 kernel: [275873.343508] Filesystem "sda6":
Corruption of
> in-memory data detected.  Shutting down filesystem: sda6

Are you absolutely sure your RAM doesn't have problems? Run memtest86.
At least I would from that error description.

mfg zmi


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
