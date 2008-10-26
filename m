Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 26 Oct 2008 01:39:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9Q8dhqr031573
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 01:39:43 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB8DDEB0FB7
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 01:39:43 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id sF3RPAETr7wCVCWC for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 01:39:43 -0700 (PDT)
Date: Sun, 26 Oct 2008 04:39:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: linux-next: left over things in linux-next after 2.6.28-c1
Message-ID: <20081026083939.GA19394@infradead.org>
References: <20081026005009.50dbbb33.sfr@canb.auug.org.au> <20081026081717.GB20872@infradead.org> <20081026193421.f5f7d8f1.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081026193421.f5f7d8f1.sfr@canb.auug.org.au>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com

On Sun, Oct 26, 2008 at 07:34:21PM +1100, Stephen Rothwell wrote:
> Presumably what was merged was slightly different (or the commits were
> split up differently).  This is the same problem I have with the kvm tree.

It should be the same, but the xfs trees have been a bit of a maze
recently, so it shouldn't be a surprise that your list got out of sync.
