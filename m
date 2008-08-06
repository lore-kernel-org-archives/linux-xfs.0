Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 19:25:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m762PRbs005899
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 19:25:28 -0700
Message-ID: <48990D53.3070305@sgi.com>
Date: Wed, 06 Aug 2008 12:32:51 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Don't release root inode until finished using it
References: <4897F434.2010309@sgi.com> <20080806000116.GA15930@infradead.org>
In-Reply-To: <20080806000116.GA15930@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, xfs-dev <xfs-dev@sgi.com>

Christoph Hellwig wrote:
> Looks good, but I've already sent a nicer version on the 26th:
> 
> [PATCH 1/6] move root inode IRELE into xfs_unmountfs
> 
> 
> Sometimes I wish people would at least glance over my patches when they
> hit the list..

Some of us are trying to fix bugs and don't have time to look at every
cleanup patch that hits the list.
