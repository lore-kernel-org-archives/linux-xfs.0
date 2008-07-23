Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 21:08:56 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6N48oUq019013
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 21:08:50 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A2B1A191D413
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 21:09:59 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id jyl3GyjNFIpdO7Jv for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 21:09:59 -0700 (PDT)
Message-ID: <4886AF06.40808@sandeen.net>
Date: Tue, 22 Jul 2008 23:09:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] XFS: Use the inode tree for finding dirty inodes
References: <1216556394-17529-1-git-send-email-david@fromorbit.com> <1216556394-17529-3-git-send-email-david@fromorbit.com> <20080722042829.GB27123@infradead.org> <20080722053019.GI6761@disturbed> <20080722072733.GA15376@infradead.org> <20080723000548.GG5947@disturbed> <488692FB.1010101@sgi.com> <4886A9A3.8090805@sandeen.net> <4886ADB6.5060109@sgi.com>
In-Reply-To: <4886ADB6.5060109@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Mark Goodwin wrote:

> As above, just run QA for cleanups.

Out of curiosity, will you trust this?  You'll run QA anyway, right?
And do you very often find errors in submitted patches by running QA?

-Eric
