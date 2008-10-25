Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 25 Oct 2008 13:20:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9PKKdjm029582
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:20:41 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2EF7C12A976C
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:20:39 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 8DzmDTGuAAAb8Vfy for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:20:39 -0700 (PDT)
Date: Sat, 25 Oct 2008 16:20:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2 v2] hook xfs to fiemap ioctl
Message-ID: <20081025202039.GD28002@infradead.org>
References: <49031E81.7040807@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49031E81.7040807@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sat, Oct 25, 2008 at 08:26:25AM -0500, Eric Sandeen wrote:
> Update & resend, including some checkpatch fixes, a bugfix, and 
> incorporating some of Christoph's and Dave's comments.
> 
> Also, here's a very hacky (don't laugh!) test app.  I'll clean it
> up at some point :)

Would be best if you could add it to xftests and write a little script
to hook it up to xfsqa.
