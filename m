Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Apr 2008 09:05:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3BG5Yw6020252
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 09:05:34 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E2BC3780D24
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 09:06:11 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id VoY8xBjFPYggVqYf for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 09:06:11 -0700 (PDT)
Date: Fri, 11 Apr 2008 12:05:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] remove INT_GET and friends
Message-ID: <20080411160541.GB26929@infradead.org>
References: <47FF794C.4020801@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FF794C.4020801@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Apr 11, 2008 at 09:44:28AM -0500, Eric Sandeen wrote:
> Thanks to hch's endian work, INT_GET etc are no longer used,
> and may as well be removed.  INT_SET is still used in
> the acl code, though.

Looks good.
