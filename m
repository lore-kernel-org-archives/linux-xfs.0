Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 00:46:09 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9R7jupP026981
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 00:45:56 -0700
Message-ID: <49057146.3000101@sgi.com>
Date: Mon, 27 Oct 2008 18:44:06 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: linux-next: left over things in linux-next after 2.6.28-c1
References: <20081026005009.50dbbb33.sfr@canb.auug.org.au> <20081026081717.GB20872@infradead.org> <20081026193421.f5f7d8f1.sfr@canb.auug.org.au> <20081026083939.GA19394@infradead.org>
In-Reply-To: <20081026083939.GA19394@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Sun, Oct 26, 2008 at 07:34:21PM +1100, Stephen Rothwell wrote:
>> Presumably what was merged was slightly different (or the commits were
>> split up differently).  This is the same problem I have with the kvm tree.
> 
> It should be the same, but the xfs trees have been a bit of a maze
> recently, so it shouldn't be a surprise that your list got out of sync.
> 

The XFS tree used for linux-next got a bit out of whack and I couldn't make
sense of the mess so I've been using a different tree for the mainline pull
requests.  We'll have this mess sorted out soon.
