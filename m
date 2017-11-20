Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48026 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751781AbdKTRyu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 Nov 2017 12:54:50 -0500
Subject: Re: [PATCH 2/2] xfs_io: stat: treat statfs.f_flags as optional
References: <20171117195457.16218-1-jeffm@suse.com>
 <20171117195457.16218-2-jeffm@suse.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <eb6a3a1c-3d0b-e266-b2af-cde661b65b7a@sandeen.net>
Date: Mon, 20 Nov 2017 11:54:49 -0600
MIME-Version: 1.0
In-Reply-To: <20171117195457.16218-2-jeffm@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: jeffm@suse.com, linux-xfs@vger.kernel.org



On 11/17/17 1:54 PM, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> Kernels prior to 2.6.36 didn't contain statfs.f_flags.  Distros with
> initial releases with kernels prior to this may not have updated
> headers with this member.

You all are brave ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
