Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32894 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752221AbeA3D5c (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 29 Jan 2018 22:57:32 -0500
Subject: Re: [PATCH 6/2] mkfs: always explain why numeric inputs are invalid
References: <151692412532.32390.5360363880930671862.stgit@magnolia>
 <20180130033922.GN9068@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <67f27414-8026-15a2-c5bb-db254e3fe325@redhat.com>
Date: Mon, 29 Jan 2018 21:57:31 -0600
MIME-Version: 1.0
In-Reply-To: <20180130033922.GN9068@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 1/29/18 9:39 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Always explain why invalid numeric inputs are not valid, and in a
> complete sentence since that's what illegal_optio() sets us up for.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
