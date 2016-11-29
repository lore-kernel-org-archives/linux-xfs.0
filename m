Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr003msb.fastweb.it ([85.18.95.87]:59213 "EHLO
        mr003msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756176AbcK2HyA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2016 02:54:00 -0500
Subject: Re: Slow file stat/deletion
References: <bef58272-f791-52bf-cc4c-1cb1b7c9efec@assyoma.it>
 <20161127221433.GV28177@dastard>
 <a5774248-db44-bdfe-2310-bb1a327756fb@assyoma.it>
 <20161128215308.GD28177@dastard>
From: Gionatan Danti <g.danti@assyoma.it>
Message-ID: <a37b6669-4ec1-074e-de51-ae15aee5a7d9@assyoma.it>
Date: Tue, 29 Nov 2016 08:53:53 +0100
MIME-Version: 1.0
In-Reply-To: <20161128215308.GD28177@dastard>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Gionatan Danti <g.danti@assyoma.it>



On 28/11/2016 22:53, Dave Chinner wrote:
>
> Nope. There's always going to be a penalty for subverting the
> filesystem's physical layout optimisations on storage subsystems
> that require physical layout optimisation for performance.
>
> Cheers,
>
> Dave.
>

Ok, very clear.

Thank you for taking the time to explain, Dave.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
