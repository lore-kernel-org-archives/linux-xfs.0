Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 17:00:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m760026G027058
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 17:00:03 -0700
Date: Tue, 5 Aug 2008 20:01:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Don't release root inode until finished using it
Message-ID: <20080806000116.GA15930@infradead.org>
References: <4897F434.2010309@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4897F434.2010309@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev <xfs-dev@sgi.com>

Looks good, but I've already sent a nicer version on the 26th:

[PATCH 1/6] move root inode IRELE into xfs_unmountfs


Sometimes I wish people would at least glance over my patches when they
hit the list..
