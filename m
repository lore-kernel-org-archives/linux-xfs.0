Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36390 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726696AbfGDDnM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Jul 2019 23:43:12 -0400
Subject: Re: [PATCH 1/9] man: create a separate GETXATTR/SETXATTR ioctl
 manpage
References: <156104944877.1174403.14568482035189263260.stgit@magnolia>
 <156104945493.1174403.4930583691574810947.stgit@magnolia>
 <82a5ede1-7b80-92a6-d3b0-4d09642e4015@sandeen.net>
 <20190704020434.GE1654093@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <af2ace5b-0ca3-c750-9ba5-eaa107920454@sandeen.net>
Date: Wed, 3 Jul 2019 22:43:10 -0500
MIME-Version: 1.0
In-Reply-To: <20190704020434.GE1654093@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 7/3/19 9:04 PM, Darrick J. Wong wrote:
>> Should we just say that this flag cannot be set on filesystems with the 
>> reflink feature enabled?
> Yes.
> 
> Thanks for picking this up, sorry I was sloppy. :( :(

Nah, documentation is hard and I'm picky.

> Happy Independence Day!~!

Tanks, man!

-Eric
 
> --D
> 
