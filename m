Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7O10fO8248471 for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 20:00:41 -0500
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1BCCD13970C6
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 18:03:23 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org
	[140.211.169.13]) by cuda.sgi.com with ESMTP id
	zyYMQ3XaesHi4oS2 for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 18:03:23 -0700 (PDT)
Received: from mail-ww0-f51.google.com (mail-ww0-f51.google.com [74.125.82.51])
	(authenticated bits=0)
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with
	ESMTP id p7O1072a016820
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=FAIL)
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 18:00:08 -0700
Received: by wwi18 with SMTP id 18so536458wwi.32
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 18:00:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110824004206.GG3162@dastard>
References: <201108231739.p7NHdXQ8008360@stout.americas.sgi.com>
	<CA+55aFxEyj8qJnr9QR3Scy7SFocEr2BNA9z4PXs7q9rpkXM1vQ@mail.gmail.com>
	<20110824004206.GG3162@dastard>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 23 Aug 2011 17:59:46 -0700
Message-ID: <CA+55aFwJAPN=EgTo-2iarhe4cFSArqB6AZAHDsuEK5EPBZVn+A@mail.gmail.com>
Subject: Re: [GIT PULL] XFS update for 3.1-rc4
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
To: Dave Chinner <david@fromorbit.com>
Cc: akpm@linux-foundation.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>

On Tue, Aug 23, 2011 at 5:42 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> I consider the context it adds to cscope searches a damn good reason
> for keeping it.

Umm. I suggest you start learning to use the tools you have, rather
than blame your inability to use them for then making crap decisions
in file naming.

Read up on the "-pN" thing to cscope.

So here's a trick of the day:

  export CSCOPEOPTIONS=-p2

or something like that. And stop using crap to excuse bad decisions.

                      Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
