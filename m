Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:44280 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbeJLAzs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Oct 2018 20:55:48 -0400
Date: Thu, 11 Oct 2018 11:27:35 -0600
From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2 00/22] xfs-4.20: major documentation surgery
Message-ID: <20181011112735.4f696d8a@lwn.net>
In-Reply-To: <20181006005154.GM12041@dastard>
References: <153862669110.26427.16504658853992750743.stgit@magnolia>
        <20181006005154.GM12041@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org

On Sat, 6 Oct 2018 10:51:54 +1000
Dave Chinner <david@fromorbit.com> wrote:

> Can you let us know whether the CC-by-SA 4.0 license is acceptible
> or not? That's really the only thing that we need clarified at this
> point - if it's OK I'll to pull this into the XFS tree for the 4.20
> merge window. If not, we'll go back to the drawing board....

OK, I've had a long conversation with the LF lawyer, and she said clearly
that we really should not be introducing CC-SA material into the kernel
source tree.  It's a pain; I really do like CC-SA better for
documentation, but it's not GPL-compatible, and that creates a problem for
the processed docs.

Sorry,

jon
