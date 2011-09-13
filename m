Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8DEwFvm066214 for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 09:58:15 -0500
Received: from mail-yx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4ACA713E595E
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 08:02:52 -0700 (PDT)
Received: from mail-yx0-f181.google.com (mail-yx0-f181.google.com
	[209.85.213.181]) by cuda.sgi.com with ESMTP id
	fQxkc027TxHVJtCy for <xfs@oss.sgi.com>;
	Tue, 13 Sep 2011 08:02:52 -0700 (PDT)
Received: by yxk30 with SMTP id 30so640993yxk.26
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 07:58:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1109130722210.21380@p34.internal.lan>
References: <alpine.DEB.2.02.1109110511250.8626@p34.internal.lan>
	<CAEuXFEzs1f7n5taYzupux3AtKmRcY4P0m7yjkUQA8aLyS8eujw@mail.gmail.com>
	<1315886706.2556.11.camel@edumazet-laptop>
	<alpine.DEB.2.02.1109130722210.21380@p34.internal.lan>
Date: Tue, 13 Sep 2011 16:58:12 +0200
Message-ID: <CAL4WiipmRyprf3nU-mgz8zE+n=Cy_Th=MT1JMnO=Qy_993++yw@mail.gmail.com>
Subject: Re: 3.1-rc4: spectacular kernel errors / filesystem crash
From: Eric Dumazet <eric.dumazet@gmail.com>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: NetDEV list <netdev@vger.kernel.org>, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>, linux-kernel@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@gmail.com>

2011/9/13 Justin Piszcz <jpiszcz@lucidpixels.com>:
>

> I found this commit here:
> http://permalink.gmane.org/gmane.linux.kernel.pci/11700
>
> Applied:
> # patch -p1 < ../ed2888e906b56769b4ffabb9c577190438aa68b8.txt patching file
> drivers/pci/probe.c
>
>

Oh, I should have sent the git anchor you can use instead of searching the web ;

git pull https://github.com/torvalds/linux.git

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
