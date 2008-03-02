Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Mar 2008 02:41:52 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m22AfVUq018701
	for <xfs@oss.sgi.com>; Sun, 2 Mar 2008 02:41:32 -0800
Date: Sun, 2 Mar 2008 05:41:53 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [REVIEW] Don't make lazy counters default for mkfs
Message-ID: <20080302104153.GD2483@josefsipek.net>
References: <op.t67mtawg3jf8g2@pc-bnaujok.melbourne.sgi.com> <87ir05h16o.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ir05h16o.fsf@basil.nowhere.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sun, Mar 02, 2008 at 11:26:07AM +0100, Andi Kleen wrote:
> "Barry Naujok" <bnaujok@sgi.com> writes:
> > 
> > Lazy counters will default to on again in xfsprogs 2.10.0 (when CI
> > support  is released).
> 
> CI is what? 

Case-insensitivity aka. case-folding.

Josef 'Jeff' Sipek.

-- 
Bad pun of the week: The formula 1 control computer suffered from a race
condition
