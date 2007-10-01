Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Oct 2007 05:55:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l91Ct6M3018659
	for <xfs@oss.sgi.com>; Mon, 1 Oct 2007 05:55:07 -0700
Message-ID: <4700EE2A.1020304@sandeen.net>
Date: Mon, 01 Oct 2007 07:55:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [GIT PULL] XFS update for 2.6.23 - revert a commit
References: <20071001072350.DF61C58C4C0A@chook.melbourne.sgi.com>
In-Reply-To: <20071001072350.DF61C58C4C0A@chook.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tim Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

Tim Shimmin wrote:
> Hi Linus,
> 
> A problem has been found for the XFS commit b394e43e995d08821588a22561c6a71a63b4ff27
> and it needs to be reverted.
> It has the potential for worse corruption than what it is meant to fix.


Whoops... that's what I get for picking it up too soon for fedora I guess!

Any background on the newly-found problem, for those of us in the peanut
gallery?

Thanks,

-Eric
