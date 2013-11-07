Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 71A657FA4
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 07:14:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4C9F7304043
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 05:14:06 -0800 (PST)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id QccqDTiJFEKmcyvK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 07 Nov 2013 05:14:04 -0800 (PST)
Date: Thu, 7 Nov 2013 14:14:01 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: xfstest failures
Message-ID: <20131107131401.GA2362@x4>
References: <20131106105451.GA31283@infradead.org>
	<20131106194417.GF6188@dastard>
	<20131107082234.GA30243@infradead.org>
	<20131107115722.GB11434@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131107115722.GB11434@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On 2013.11.07 at 22:57 +1100, Dave Chinner wrote:
> This is a perfect example of what is wrong with the way XFS is being
> maintained right now.
> 
> That's the fundamental problem here.  When I change stuff, I can't
> get the maintainers to do anything with the code I post unless I put
> on my cranky pants and start shouting and making people cry. I hate
> having to do this, but it seems like it's the only thing that the
> maintainers respond to.
> 
> Quite frankly, XFS upstream is completely dysfunctional right now
> and, as such, it's no longer a fun thing to work on.

Then why don't you just set up a couple of git trees on git.kernel.org
and ask Linus to pull directly from those?

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
