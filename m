Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f169.google.com ([209.85.160.169]:39818 "EHLO
        mail-qt1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731280AbeLTSjs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Dec 2018 13:39:48 -0500
Received: by mail-qt1-f169.google.com with SMTP id n21so2930327qtl.6
        for <linux-xfs@vger.kernel.org>; Thu, 20 Dec 2018 10:39:48 -0800 (PST)
Received: from lud1.home ([189.115.213.104])
        by smtp.gmail.com with ESMTPSA id 20sm5236020qtp.54.2018.12.20.10.39.45
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 20 Dec 2018 10:39:46 -0800 (PST)
Date: Thu, 20 Dec 2018 16:39:43 -0200
From: Luciano ES <lucmove@gmail.com>
Subject: Re: Same size drive has less usable space
Message-ID: <20181220163943.5d8c6c2c@lud1.home>
In-Reply-To: <710b005e-0738-b793-3014-2234fcee84ad@sandeen.net>
References: <20181220131305.2a84b717@lud1.home>
        <6ab0a568-4732-905a-d45d-209f4bb0cfb0@sandeen.net>
        <20181220145529.1292ec61@lud1.home>
        <710b005e-0738-b793-3014-2234fcee84ad@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Thu, 20 Dec 2018 11:32:33 -0600, Eric Sandeen wrote:

> but ok, I missed that you had 2k blocks on your backup disk.... I
> don't really know what you're trying to do here, TBH.

Smaller blocks waste less space. In ext3/4, I've always used 2k or 
even 1k blocks. It does save space. Doesn't it in XFS too?

-- 
Luciano ES
>>
