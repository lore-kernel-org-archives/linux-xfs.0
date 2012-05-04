Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q44Gp0Uq058084 for <xfs@oss.sgi.com>; Fri, 4 May 2012 11:51:00 -0500
Received: from mail-yx0-f181.google.com (mail-yx0-f181.google.com
	[209.85.213.181]) by cuda.sgi.com with ESMTP id
	pgY6JsE3WJLy8NqJ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 04 May 2012 09:50:59 -0700 (PDT)
Received: by yenq2 with SMTP id q2so3414091yen.26
	for <xfs@oss.sgi.com>; Fri, 04 May 2012 09:50:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120504163237.GA6128@nsrc.org>
References: <20120502184450.GA2557@nsrc.org>
	<4FA27EF8.6040002@hardwarefreak.com>
	<20120503204157.GC4387@nsrc.org>
	<4FA3047D.8060908@hardwarefreak.com>
	<20120504163237.GA6128@nsrc.org>
Date: Fri, 4 May 2012 18:50:59 +0200
Message-ID: <CAAxjCEzcqhK3nUyA35oCGn7vTaK_HOanjgW1=pp2xfyLqZzPkQ@mail.gmail.com>
Subject: Re: Storage server, hung tasks and tracebacks
From: Stefan Ring <stefanrin@gmail.com>
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
To: Brian Candler <B.Candler@pobox.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

> I am completely at a loss with all this... I've never seen a Unix/Linux
> system behave so unreliably.

Fortunately, Linux doesn't have to prove itself anymore, these days.
Usually these things happen on really crappy hardware. I had a new HP
Proliant Blade server a few months ago, and it would randomly lock up
and produce NMIs for no apparent reason. It has inflicted a decent
amount of pain on me. Finally, it was replaced with an identical
model, and all problems were instantly gone.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
