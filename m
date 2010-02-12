Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CKbtPo025130
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 14:37:55 -0600
Received: from mail-ew0-f227.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55D9D1CBE8F
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 12:39:10 -0800 (PST)
Received: from mail-ew0-f227.google.com (mail-ew0-f227.google.com
	[209.85.219.227]) by cuda.sgi.com with ESMTP id
	xtBE02iUSljCdro9 for <linux-xfs@oss.sgi.com>;
	Fri, 12 Feb 2010 12:39:10 -0800 (PST)
Received: by ewy27 with SMTP id 27so3041666ewy.18
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 12:39:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <hl4dpt$fq2$1@ger.gmane.org>
References: <2d460de71002120607g763afc2bt2167fcfbf4664b56@mail.gmail.com>
	<4B75738D.80108@sandeen.net>
	<2d460de71002120845ue5b127ex1033b37ae5ff6ba2@mail.gmail.com>
	<2d460de71002120902g3bda548t4e202dfe43a0c742@mail.gmail.com>
	<hl438l$bhm$1@ger.gmane.org> <4B7594D3.6040304@sandeen.net>
	<hl45te$kjs$1@ger.gmane.org> <hl4dpt$fq2$1@ger.gmane.org>
Date: Fri, 12 Feb 2010 21:39:09 +0100
Message-ID: <2d460de71002121239y42ec9671id5e147e9709e42ac@mail.gmail.com>
Subject: Re: xfs_repair on a 1.5 TiB image has been hanging for about an hour,
	now
From: Richard Hartmann <richih.mailinglist@gmail.com>
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
To: Nicolas Stransky <nico@stransky.cx>
Cc: linux-xfs@oss.sgi.com

On Fri, Feb 12, 2010 at 21:30, Nicolas Stransky <nico@stransky.cx> wrote:
> The -P option allowed me to complete xfs_repair successfully, but it
> also deleted almost everything on the filesystem... A directory that I
> could mount -o ro,norecovery before, with tens of GB of data in it, is
> now empty... That is really too bad.

Do you still have a backup of the raw disk?


Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
