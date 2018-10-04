Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60292 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727540AbeJDXmA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Oct 2018 19:42:00 -0400
Date: Thu, 4 Oct 2018 09:47:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [GIT PULL] xfs: fixes for 4.19-rc6
Message-ID: <20181004164753.GB5849@kroah.com>
References: <20181004010311.GU31060@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181004010311.GU31060@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: djwong@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Thu, Oct 04, 2018 at 11:03:12AM +1000, Dave Chinner wrote:
> Hi Greg,
> 
> Can you please pull the XFS from the tag listed below. It's a bit
> bigger than that I'd like this late in the cycle, but we've had a
> few challenges getting ourselves sorted out this cycle. Details
> of the contents are in the pull-req output below. This has been be
> run through xfstests over the past week, and merges against 4.19-rc6
> cleanly.
> 
> FYI, there is likely to be one more XFS fix for this cycle - we've
> just tracked down the source of a clone_file_range() data corruption
> so I'll send that as a separate pullreq once Darrick's fix is
> reviewed and tested.

Now merged, and thanks for the heads-up on a future patch.

greg k-h
