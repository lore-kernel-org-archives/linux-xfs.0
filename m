Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:35115 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbcKCT2Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2016 15:28:24 -0400
Received: by mail-yw0-f169.google.com with SMTP id h14so62465426ywa.2
        for <linux-xfs@vger.kernel.org>; Thu, 03 Nov 2016 12:28:24 -0700 (PDT)
MIME-Version: 1.0
From: Marcin Sura <mailing-lists@sura.pl>
Date: Thu, 3 Nov 2016 20:28:22 +0100
Message-ID: <CACNifpV5z3r0WB3xypSfGxk6E-=b+3TWrsS4Od7+bKwmmD3yeA@mail.gmail.com>
Subject: Can I add external log device after filesystem was created?
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

I've created filesystem with default mkfs.xfs command, started to use
the filesystem. Few days later I've got nice SSD-based lun which can
be used as external log device.

Can I add that lun as external log device to an existing filesystem? How?

BR
Marcin
