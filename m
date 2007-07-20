Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jul 2007 18:16:05 -0700 (PDT)
Received: from smtp2.linux-foundation.org (smtp2.linux-foundation.org [207.189.120.14])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6K1G1bm021306
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 18:16:02 -0700
Date: Thu, 19 Jul 2007 18:15:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] XFS update
In-Reply-To: <46A00752.4040103@sgi.com>
Message-ID: <alpine.LFD.0.999.0707191811550.27249@woody.linux-foundation.org>
References: <469F7329.9080603@sgi.com> <alpine.LFD.0.999.0707191528250.27249@woody.linux-foundation.org>
 <46A00752.4040103@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: akpm@linux-foundation.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org



On Fri, 20 Jul 2007, Timothy Shimmin wrote:
> 
> The window between pulling in and applying changes was obviously
> large enough for Nick's changes to get in.

Don't worry.

Basically, merging is my job, and I happily do it. If I hit something that 
makes me nervous enough, I'll just push back and say "please merge this 
for me", but if I merge up conflicts on my own, I generally just let 
people know that I did it - not because it's a *problem*, but as a 
heads-up to let people know that they should double-check the end result.

Quite frankly, real merge conflicts happen rarely enough that it really 
isn't a problem. And 99% of the time, the conflicts are really pretty damn 
obvious, and doing them isn't a problem at all. So even when I ask people 
to "please check", most of the time I expect that the end result is fine.

So my "please double-check" was in no way meant to be a criticism or a 
"please do this better next time". It was _literally_ just meant to be 
just that and nothing more: a "please double-check", especially since for 
something like XFS, I'm not actually doing any testing personally.

So no worries.

		Linus
