Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:54680 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728605AbeLTTHs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Dec 2018 14:07:48 -0500
Date: Thu, 20 Dec 2018 19:07:45 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2] iomap: take responsibility for the filesystem iomap
 code
Message-ID: <20181220190745.GW2217@ZenIV.linux.org.uk>
References: <20181220053622.GD27176@magnolia>
 <20181220190401.GD27208@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181220190401.GD27208@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, Amir Goldstein <amir73il@gmail.com>

On Thu, Dec 20, 2018 at 11:04:01AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> XFS is the primary user of the filesystem iomap code, so we (the XFS
> community, specifically) will explicitly take responsibility for its
> maintenance.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

ACK from me, for what it's worth - you guys brought it in, you appear
to actively maintain it, so it's your headac^Wresponsibility.
