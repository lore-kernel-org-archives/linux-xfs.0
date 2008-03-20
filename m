Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Mar 2008 13:36:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2KKadUQ006316
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 13:36:42 -0700
Date: Thu, 20 Mar 2008 16:37:12 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] XFSQA 103: filter ln output
Message-ID: <20080320203712.GC16357@josefsipek.net>
References: <20080320063245.GA103491721@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320063245.GA103491721@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Mar 20, 2008 at 05:32:45PM +1100, David Chinner wrote:
> Move recent versions of ln (i.e. debian unstable) have
> a different error output. update the filter to handle this.
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>

Fixes the failure I reported few days ago.

Josef 'Jeff' Sipek.

-- 
Real Programmers consider "what you see is what you get" to be just as bad a
concept in Text Editors as it is in women. No, the Real Programmer wants a
"you asked for it, you got it" text editor -- complicated, cryptic,
powerful, unforgiving, dangerous.
