Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o58HlksN225031 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 12:47:46 -0500
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E114B13120EA
	for <xfs@oss.sgi.com>; Tue,  8 Jun 2010 10:53:14 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org
	[140.211.169.13]) by cuda.sgi.com with ESMTP id
	SXnBdRdtXyL109Rm for <xfs@oss.sgi.com>;
	Tue, 08 Jun 2010 10:53:14 -0700 (PDT)
Date: Tue, 8 Jun 2010 10:50:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/6] writeback: tracing and fixes V4
Message-Id: <20100608105018.f7f82a1e.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006081039370.4506@i5.linux-foundation.org>
References: <1275957487-23633-1-git-send-email-david@fromorbit.com>
	<alpine.LFD.2.00.1006081039370.4506@i5.linux-foundation.org>
Mime-Version: 1.0
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, 8 Jun 2010 10:41:28 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 8 Jun 2010, Dave Chinner wrote:
> >
> > Can you please consider this patch series for 2.6.35?
> 
> Yeah, no. See the several lkml discussions and the -rc2 announcement about 
> how I do _not_ intend to merge anything even remotely "new code" this time 
> around.
> 
> So purely regression fixes and serious bugfixes (oopses/security issues).

Linus would have merged it.

> 			Kubys

But his evil twin got ahold of the keyboard.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
