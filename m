Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr002msb.fastweb.it ([85.18.95.86]:46514 "EHLO
        mr002msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751308AbdHSQPd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Aug 2017 12:15:33 -0400
Subject: Re: Estimate =?UTF-8?Q?xfs=5Frepair=20run=20time?=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sat, 19 Aug 2017 18:15:28 +0200
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <20170819154804.GS4796@magnolia>
References: <22ed5cf73260ae39bf59779b302d8ad3@assyoma.it>
 <d80ca25cd28ec433c39a7d7d22c4e371@assyoma.it>
 <20170819154804.GS4796@magnolia>
Message-ID: <3fcdaa5ea4365a1ddb7c76070236e6b3@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, g.danti@assyoma.it

Il 19-08-2017 17:48 Darrick J. Wong ha scritto:
> Should work fine; be sure to set the extent size hint to reduce 
> fragmentation.

Hi, do you mean tuning the "allocsize" mount option? If I remember 
correctly, this parameter should be auto-tuned by XFS during normal 
operation, right?

Any thoughts on the xfs_repair matter?
Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
