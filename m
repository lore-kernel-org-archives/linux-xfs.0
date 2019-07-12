Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52578 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727226AbfGLRbn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Jul 2019 13:31:43 -0400
Subject: Re: [PATCH] xfs: remove flags argument from xfs_getsb
References: <6a2da6f7-8c5c-7e10-3a5c-01e175f3382d@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5d8b5439-15b9-4177-33f2-0e2dfb46bbce@sandeen.net>
Date: Fri, 12 Jul 2019 12:31:41 -0500
MIME-Version: 1.0
In-Reply-To: <6a2da6f7-8c5c-7e10-3a5c-01e175f3382d@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 7/12/19 12:03 PM, Eric Sandeen wrote:
> The flags argument is only checked for XBF_TRYLOCK, and no callers have
> used this flag for nearly 10 years.

Uh I already sent this and Darrick already merged it so yay me.

Had my tree checked out to 5.1, derp.  :)

Sorry for the noise,
-Eric
