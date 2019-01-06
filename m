Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:44400 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfAFK0u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Jan 2019 05:26:50 -0500
Received: by mail-yw1-f65.google.com with SMTP id b63so14863772ywc.11
        for <linux-xfs@vger.kernel.org>; Sun, 06 Jan 2019 02:26:50 -0800 (PST)
MIME-Version: 1.0
References: <20190105102556.GA4200@nevermore.lan> <20190105174617.GH12689@magnolia>
 <9dc5afc1-b898-6808-e649-753682d79227@sandeen.net>
In-Reply-To: <9dc5afc1-b898-6808-e649-753682d79227@sandeen.net>
From: Achilles Gaikwad <agaikwad@redhat.com>
Date: Sun, 6 Jan 2019 15:56:38 +0530
Message-ID: <CAK0MK2quww5BQcB5R5ATORDwmmKdzu5odC30Th6BxzXhECQASQ@mail.gmail.com>
Subject: Re: [PATCH] xfs_quota: fix false error reporting of project
 inheritance flag is not set
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Steven Gardner <sgardner@redhat.com>, sandeen@sandeen.net

Thanks Darrick and Eric, I'll move the macro into the if condition and
send a v2 for this.

Best,
- Achilles
