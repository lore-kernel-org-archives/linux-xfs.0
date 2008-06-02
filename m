Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 01 Jun 2008 23:08:04 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m52682rh011882
	for <xfs@oss.sgi.com>; Sun, 1 Jun 2008 23:08:02 -0700
Date: Mon, 2 Jun 2008 02:08:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: REVIEW: Zero uninitialised xfs_da_args structure in xfs_dir2.c
Message-ID: <20080602060855.GA25939@infradead.org>
References: <op.ub3wttk53jf8g2@pc-bnaujok.melbourne.sgi.com> <20080602055028.GA1629@infradead.org> <op.ub3xz9ui3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ub3xz9ui3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Jun 02, 2008 at 04:08:23PM +1000, Barry Naujok wrote:
> I agree, so here's the alternative patch which makes them all
> consistent:

Looks good.
