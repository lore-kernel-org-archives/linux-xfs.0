Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ACBFB7F47
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 18:13:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3FA07AC013
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 16:13:03 -0700 (PDT)
Received: from mail-ve0-f172.google.com (mail-ve0-f172.google.com
	[209.85.128.172]) by cuda.sgi.com with ESMTP id
	GHdTzgwno68WAiBG (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 16:13:01 -0700 (PDT)
Received: by mail-ve0-f172.google.com with SMTP id oz11so4199909veb.17
	for <xfs@oss.sgi.com>; Thu, 08 May 2014 16:13:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140508211217.GC26353@dastard>
References: <20140508211217.GC26353@dastard>
Date: Thu, 8 May 2014 16:13:00 -0700
Message-ID: <CA+55aFy9B=OcqfniMiq+EhDa_rzc0-owcmbUck1FmBOU+Q-Dvw@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: fixes for 3.15-rc5
From: Linus Torvalds <torvalds@linux-foundation.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Thu, May 8, 2014 at 2:12 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> BTW, will GPG signing these pull requests cause you problems?

Nope. But I won't be checking email signatures. GPG email signing is
so badly done that afaik only one or two email clients support it.

> I've
> been signing everything "official" I send as the XFS maintainer
> (e.g. notifications of tree updates) and I figured that pull
> requests are about as "official" as it gets. The tag is signed, so
> I'm not particularly worried either way...

.. what tag? You point me at

>   git://oss.sgi.com/xfs/xfs.git xfs-fixes-for-3.15-rc5

and that is definitely not a tag.

Did you *mean* to point me at refs/tags/xfs-for-linus-3.15-rc5, perhaps?

I've not pulled due to the ambiguity of the pull request.

           Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
